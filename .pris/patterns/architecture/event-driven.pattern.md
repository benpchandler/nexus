---
pattern_id: "event-driven-architecture"
name: "Event-Driven Architecture with Domain Events"
language: "python"
framework: "fastapi"
type: "architecture"
tags: ["event-driven", "domain-events", "pub-sub", "architecture", "microservices"]
description: "Event-driven architecture pattern with domain events, event bus, and handlers"
usage_prompt: "When building decoupled systems that react to business events, use this pattern for scalability"
common_mistakes:
  - "Not handling event ordering requirements"
  - "Missing event versioning strategy"
  - "No dead letter queue handling"
  - "Synchronous event processing"
success_rate: 0.88
usage_count: 23
---

```python
from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from datetime import datetime
from typing import Dict, List, Any, Type, Callable, Optional
from uuid import UUID, uuid4
import json
import asyncio
from enum import Enum
import logging

logger = logging.getLogger(__name__)

# Base Event Classes
@dataclass
class DomainEvent(ABC):
    """Base class for all domain events."""
    event_id: UUID = field(default_factory=uuid4)
    aggregate_id: str = field(default="")
    occurred_at: datetime = field(default_factory=datetime.utcnow)
    version: int = 1
    
    @property
    @abstractmethod
    def event_name(self) -> str:
        """Return the name of the event."""
        pass
    
    def to_dict(self) -> Dict[str, Any]:
        """Serialize event to dictionary."""
        return {
            "event_id": str(self.event_id),
            "event_name": self.event_name,
            "aggregate_id": self.aggregate_id,
            "occurred_at": self.occurred_at.isoformat(),
            "version": self.version,
            "data": self.__dict__
        }

# Event Bus Interface
class EventBus(ABC):
    """Abstract event bus interface."""
    
    @abstractmethod
    async def publish(self, event: DomainEvent) -> None:
        """Publish an event to the bus."""
        pass
    
    @abstractmethod
    def subscribe(self, event_type: Type[DomainEvent], handler: Callable) -> None:
        """Subscribe a handler to an event type."""
        pass

# In-Memory Event Bus Implementation
class InMemoryEventBus(EventBus):
    """Simple in-memory event bus for development/testing."""
    
    def __init__(self):
        self._handlers: Dict[Type[DomainEvent], List[Callable]] = {}
        self._middleware: List[Callable] = []
    
    async def publish(self, event: DomainEvent) -> None:
        """Publish event to all registered handlers."""
        event_type = type(event)
        
        # Apply middleware
        for middleware in self._middleware:
            event = await middleware(event)
        
        # Get handlers for this event type
        handlers = self._handlers.get(event_type, [])
        
        # Execute handlers concurrently
        if handlers:
            await asyncio.gather(
                *[self._execute_handler(handler, event) for handler in handlers],
                return_exceptions=True
            )
        
        logger.info(f"Published event: {event.event_name} ({event.event_id})")
    
    def subscribe(self, event_type: Type[DomainEvent], handler: Callable) -> None:
        """Register a handler for an event type."""
        if event_type not in self._handlers:
            self._handlers[event_type] = []
        
        self._handlers[event_type].append(handler)
        logger.info(f"Subscribed handler {handler.__name__} to {event_type.__name__}")
    
    def add_middleware(self, middleware: Callable) -> None:
        """Add middleware to process events before handlers."""
        self._middleware.append(middleware)
    
    async def _execute_handler(self, handler: Callable, event: DomainEvent) -> None:
        """Execute a single handler with error handling."""
        try:
            if asyncio.iscoroutinefunction(handler):
                await handler(event)
            else:
                handler(event)
        except Exception as e:
            logger.error(f"Error in handler {handler.__name__}: {e}", exc_info=True)
            # Could publish to dead letter queue here

# Event Store for Event Sourcing
class EventStore:
    """Store for persisting domain events."""
    
    def __init__(self, db_session):
        self.db = db_session
    
    async def append(self, aggregate_id: str, events: List[DomainEvent]) -> None:
        """Append events to the store."""
        for event in events:
            event_data = EventData(
                event_id=event.event_id,
                aggregate_id=aggregate_id,
                event_type=event.event_name,
                event_data=json.dumps(event.to_dict()),
                occurred_at=event.occurred_at,
                version=event.version
            )
            self.db.add(event_data)
        
        await self.db.commit()
    
    async def get_events(
        self, 
        aggregate_id: str, 
        from_version: int = 0
    ) -> List[DomainEvent]:
        """Retrieve events for an aggregate."""
        events = self.db.query(EventData).filter(
            EventData.aggregate_id == aggregate_id,
            EventData.version > from_version
        ).order_by(EventData.version).all()
        
        return [self._deserialize_event(e) for e in events]
    
    def _deserialize_event(self, event_data: EventData) -> DomainEvent:
        """Deserialize event from storage."""
        # Implementation depends on your event registry
        pass

# Domain Events Examples
@dataclass
class UserRegistered(DomainEvent):
    """Event fired when a new user registers."""
    user_id: str
    email: str
    name: str
    
    @property
    def event_name(self) -> str:
        return "user.registered"

@dataclass
class OrderPlaced(DomainEvent):
    """Event fired when an order is placed."""
    order_id: str
    user_id: str
    total_amount: float
    items: List[Dict[str, Any]]
    
    @property
    def event_name(self) -> str:
        return "order.placed"

@dataclass
class PaymentProcessed(DomainEvent):
    """Event fired when payment is processed."""
    payment_id: str
    order_id: str
    amount: float
    status: str
    
    @property
    def event_name(self) -> str:
        return "payment.processed"

# Event Handlers
class EmailService:
    """Service that handles email notifications."""
    
    async def handle_user_registered(self, event: UserRegistered) -> None:
        """Send welcome email to new user."""
        logger.info(f"Sending welcome email to {event.email}")
        # Email sending logic here
        await self._send_email(
            to=event.email,
            subject="Welcome!",
            template="welcome",
            context={"name": event.name}
        )
    
    async def handle_order_placed(self, event: OrderPlaced) -> None:
        """Send order confirmation email."""
        logger.info(f"Sending order confirmation for order {event.order_id}")
        # Fetch user details and send email
        
    async def _send_email(self, **kwargs):
        """Actual email sending implementation."""
        pass

class InventoryService:
    """Service that handles inventory updates."""
    
    async def handle_order_placed(self, event: OrderPlaced) -> None:
        """Update inventory when order is placed."""
        logger.info(f"Updating inventory for order {event.order_id}")
        
        for item in event.items:
            await self._decrease_stock(
                product_id=item["product_id"],
                quantity=item["quantity"]
            )
    
    async def _decrease_stock(self, product_id: str, quantity: int):
        """Decrease product stock."""
        pass

# Aggregate Example with Event Sourcing
class Order:
    """Order aggregate that produces events."""
    
    def __init__(self, order_id: str):
        self.order_id = order_id
        self.status = "pending"
        self.items = []
        self.total = 0.0
        self._events: List[DomainEvent] = []
    
    def place_order(self, user_id: str, items: List[Dict]) -> None:
        """Place a new order."""
        if self.status != "pending":
            raise ValueError("Order already placed")
        
        self.status = "placed"
        self.items = items
        self.total = sum(item["price"] * item["quantity"] for item in items)
        
        # Record the event
        event = OrderPlaced(
            aggregate_id=self.order_id,
            order_id=self.order_id,
            user_id=user_id,
            total_amount=self.total,
            items=items
        )
        self._events.append(event)
    
    def process_payment(self, payment_id: str, amount: float) -> None:
        """Process payment for the order."""
        if self.status != "placed":
            raise ValueError("Invalid order status for payment")
        
        if amount != self.total:
            raise ValueError("Payment amount doesn't match order total")
        
        self.status = "paid"
        
        event = PaymentProcessed(
            aggregate_id=self.order_id,
            payment_id=payment_id,
            order_id=self.order_id,
            amount=amount,
            status="success"
        )
        self._events.append(event)
    
    def get_uncommitted_events(self) -> List[DomainEvent]:
        """Get events that haven't been persisted yet."""
        return self._events.copy()
    
    def mark_events_committed(self) -> None:
        """Clear uncommitted events after persistence."""
        self._events.clear()

# FastAPI Integration
from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session

app = FastAPI()

# Initialize event bus
event_bus = InMemoryEventBus()

# Register handlers
email_service = EmailService()
inventory_service = InventoryService()

event_bus.subscribe(UserRegistered, email_service.handle_user_registered)
event_bus.subscribe(OrderPlaced, email_service.handle_order_placed)
event_bus.subscribe(OrderPlaced, inventory_service.handle_order_placed)

# API Endpoints
@app.post("/users/register")
async def register_user(
    email: str,
    name: str,
    password: str,
    db: Session = Depends(get_db)
):
    """Register a new user and publish event."""
    # Create user in database
    user = User(email=email, name=name)
    db.add(user)
    db.commit()
    
    # Publish domain event
    event = UserRegistered(
        aggregate_id=str(user.id),
        user_id=str(user.id),
        email=email,
        name=name
    )
    await event_bus.publish(event)
    
    return {"user_id": user.id, "message": "User registered successfully"}

@app.post("/orders")
async def create_order(
    user_id: str,
    items: List[Dict],
    db: Session = Depends(get_db)
):
    """Create a new order using event sourcing."""
    # Create order aggregate
    order = Order(order_id=str(uuid4()))
    order.place_order(user_id, items)
    
    # Get uncommitted events
    events = order.get_uncommitted_events()
    
    # Store events
    event_store = EventStore(db)
    await event_store.append(order.order_id, events)
    
    # Publish events
    for event in events:
        await event_bus.publish(event)
    
    order.mark_events_committed()
    
    return {"order_id": order.order_id, "status": order.status}

# Middleware for Event Context
async def event_context_middleware(event: DomainEvent) -> DomainEvent:
    """Add context information to events."""
    # Add correlation ID, user context, etc.
    return event

event_bus.add_middleware(event_context_middleware)
```

## Database Models

```python
from sqlalchemy import Column, String, DateTime, Integer, Text
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class EventData(Base):
    """Persistence model for domain events."""
    __tablename__ = "domain_events"
    
    event_id = Column(String, primary_key=True)
    aggregate_id = Column(String, index=True, nullable=False)
    event_type = Column(String, nullable=False)
    event_data = Column(Text, nullable=False)
    occurred_at = Column(DateTime, nullable=False)
    version = Column(Integer, nullable=False)
    
    # Additional metadata
    correlation_id = Column(String, index=True)
    causation_id = Column(String)
    user_id = Column(String)
```

## Tests

```python
import pytest
from unittest.mock import Mock, AsyncMock

@pytest.mark.asyncio
async def test_event_bus_publishes_to_handlers():
    """Test that event bus delivers events to subscribed handlers."""
    # Arrange
    bus = InMemoryEventBus()
    handler = AsyncMock()
    
    event = UserRegistered(
        user_id="123",
        email="test@example.com",
        name="Test User"
    )
    
    bus.subscribe(UserRegistered, handler)
    
    # Act
    await bus.publish(event)
    
    # Assert
    handler.assert_called_once_with(event)

@pytest.mark.asyncio
async def test_order_aggregate_produces_events():
    """Test that order aggregate produces correct events."""
    # Arrange
    order = Order("order-123")
    items = [
        {"product_id": "prod-1", "price": 10.0, "quantity": 2},
        {"product_id": "prod-2", "price": 15.0, "quantity": 1}
    ]
    
    # Act
    order.place_order("user-123", items)
    events = order.get_uncommitted_events()
    
    # Assert
    assert len(events) == 1
    assert isinstance(events[0], OrderPlaced)
    assert events[0].total_amount == 35.0
```

## Production Considerations

1. **Message Broker**: Use RabbitMQ, Kafka, or Redis Streams for production
2. **Event Ordering**: Implement event ordering guarantees where needed
3. **Idempotency**: Make event handlers idempotent
4. **Monitoring**: Track event processing metrics and failures
5. **Schema Evolution**: Version events and handle schema changes
6. **Dead Letter Queue**: Handle failed events appropriately