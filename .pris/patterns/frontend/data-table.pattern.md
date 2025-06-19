---
pattern_id: "react-data-table"
name: "Data Table with Sorting, Filtering, and Pagination"
language: "typescript"
framework: "react"
type: "frontend"
tags: ["table", "data-grid", "sorting", "filtering", "pagination", "react", "shadcn"]
description: "Reusable data table component with sorting, filtering, pagination, and row selection"
usage_prompt: "When displaying tabular data with interactive features, use this pattern for consistent UX"
common_mistakes:
  - "Not memoizing expensive computations"
  - "Missing loading and empty states"
  - "Poor mobile responsiveness"
  - "Not virtualizing large datasets"
success_rate: 0.91
usage_count: 52
---

```typescript
import React, { useState, useMemo, useCallback } from 'react';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Checkbox } from '@/components/ui/checkbox';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import {
  ChevronUp,
  ChevronDown,
  ChevronsUpDown,
  ChevronLeft,
  ChevronRight,
} from 'lucide-react';

// Types
interface Column<T> {
  key: keyof T;
  header: string;
  sortable?: boolean;
  filterable?: boolean;
  render?: (value: any, row: T) => React.ReactNode;
  width?: string;
}

interface DataTableProps<T> {
  data: T[];
  columns: Column<T>[];
  pageSize?: number;
  searchable?: boolean;
  selectable?: boolean;
  onSelectionChange?: (selectedRows: T[]) => void;
  loading?: boolean;
  emptyMessage?: string;
}

type SortDirection = 'asc' | 'desc' | null;

export function DataTable<T extends { id: string | number }>({
  data,
  columns,
  pageSize = 10,
  searchable = true,
  selectable = false,
  onSelectionChange,
  loading = false,
  emptyMessage = 'No data available',
}: DataTableProps<T>) {
  // State
  const [currentPage, setCurrentPage] = useState(1);
  const [searchTerm, setSearchTerm] = useState('');
  const [sortColumn, setSortColumn] = useState<keyof T | null>(null);
  const [sortDirection, setSortDirection] = useState<SortDirection>(null);
  const [selectedRows, setSelectedRows] = useState<Set<string | number>>(new Set());
  const [rowsPerPage, setRowsPerPage] = useState(pageSize);

  // Filtering
  const filteredData = useMemo(() => {
    if (!searchTerm) return data;

    return data.filter((row) => {
      return columns.some((column) => {
        if (!column.filterable) return false;
        const value = row[column.key];
        return String(value).toLowerCase().includes(searchTerm.toLowerCase());
      });
    });
  }, [data, columns, searchTerm]);

  // Sorting
  const sortedData = useMemo(() => {
    if (!sortColumn || !sortDirection) return filteredData;

    return [...filteredData].sort((a, b) => {
      const aValue = a[sortColumn];
      const bValue = b[sortColumn];

      if (aValue === null || aValue === undefined) return 1;
      if (bValue === null || bValue === undefined) return -1;

      if (aValue < bValue) return sortDirection === 'asc' ? -1 : 1;
      if (aValue > bValue) return sortDirection === 'asc' ? 1 : -1;
      return 0;
    });
  }, [filteredData, sortColumn, sortDirection]);

  // Pagination
  const totalPages = Math.ceil(sortedData.length / rowsPerPage);
  const paginatedData = useMemo(() => {
    const start = (currentPage - 1) * rowsPerPage;
    const end = start + rowsPerPage;
    return sortedData.slice(start, end);
  }, [sortedData, currentPage, rowsPerPage]);

  // Handlers
  const handleSort = useCallback((column: keyof T) => {
    if (sortColumn === column) {
      if (sortDirection === 'asc') {
        setSortDirection('desc');
      } else if (sortDirection === 'desc') {
        setSortDirection(null);
        setSortColumn(null);
      }
    } else {
      setSortColumn(column);
      setSortDirection('asc');
    }
  }, [sortColumn, sortDirection]);

  const handleSelectAll = useCallback((checked: boolean) => {
    if (checked) {
      const allIds = paginatedData.map((row) => row.id);
      setSelectedRows(new Set(allIds));
      onSelectionChange?.(paginatedData);
    } else {
      setSelectedRows(new Set());
      onSelectionChange?.([]);
    }
  }, [paginatedData, onSelectionChange]);

  const handleSelectRow = useCallback((rowId: string | number, checked: boolean) => {
    const newSelection = new Set(selectedRows);
    if (checked) {
      newSelection.add(rowId);
    } else {
      newSelection.delete(rowId);
    }
    setSelectedRows(newSelection);
    
    const selectedData = data.filter((row) => newSelection.has(row.id));
    onSelectionChange?.(selectedData);
  }, [selectedRows, data, onSelectionChange]);

  const handlePageChange = useCallback((page: number) => {
    setCurrentPage(page);
    setSelectedRows(new Set()); // Clear selection on page change
  }, []);

  // Render helpers
  const renderSortIcon = (column: keyof T) => {
    if (sortColumn !== column) {
      return <ChevronsUpDown className="ml-2 h-4 w-4" />;
    }
    return sortDirection === 'asc' ? (
      <ChevronUp className="ml-2 h-4 w-4" />
    ) : (
      <ChevronDown className="ml-2 h-4 w-4" />
    );
  };

  const isAllSelected = paginatedData.length > 0 && 
    paginatedData.every((row) => selectedRows.has(row.id));
  const isPartiallySelected = paginatedData.some((row) => selectedRows.has(row.id)) && 
    !isAllSelected;

  // Loading state
  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      {/* Search and Controls */}
      {searchable && (
        <div className="flex items-center justify-between">
          <Input
            placeholder="Search..."
            value={searchTerm}
            onChange={(e) => {
              setSearchTerm(e.target.value);
              setCurrentPage(1);
            }}
            className="max-w-sm"
          />
          <Select
            value={rowsPerPage.toString()}
            onValueChange={(value) => {
              setRowsPerPage(Number(value));
              setCurrentPage(1);
            }}
          >
            <SelectTrigger className="w-[180px]">
              <SelectValue placeholder="Rows per page" />
            </SelectTrigger>
            <SelectContent>
              {[10, 20, 30, 50, 100].map((size) => (
                <SelectItem key={size} value={size.toString()}>
                  {size} rows
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
      )}

      {/* Table */}
      <div className="rounded-md border">
        <Table>
          <TableHeader>
            <TableRow>
              {selectable && (
                <TableHead className="w-[50px]">
                  <Checkbox
                    checked={isAllSelected}
                    indeterminate={isPartiallySelected}
                    onCheckedChange={handleSelectAll}
                  />
                </TableHead>
              )}
              {columns.map((column) => (
                <TableHead
                  key={String(column.key)}
                  className={column.sortable ? 'cursor-pointer select-none' : ''}
                  style={{ width: column.width }}
                  onClick={() => column.sortable && handleSort(column.key)}
                >
                  <div className="flex items-center">
                    {column.header}
                    {column.sortable && renderSortIcon(column.key)}
                  </div>
                </TableHead>
              ))}
            </TableRow>
          </TableHeader>
          <TableBody>
            {paginatedData.length === 0 ? (
              <TableRow>
                <TableCell
                  colSpan={columns.length + (selectable ? 1 : 0)}
                  className="text-center py-8 text-muted-foreground"
                >
                  {emptyMessage}
                </TableCell>
              </TableRow>
            ) : (
              paginatedData.map((row) => (
                <TableRow key={row.id}>
                  {selectable && (
                    <TableCell>
                      <Checkbox
                        checked={selectedRows.has(row.id)}
                        onCheckedChange={(checked) => 
                          handleSelectRow(row.id, checked as boolean)
                        }
                      />
                    </TableCell>
                  )}
                  {columns.map((column) => (
                    <TableCell key={String(column.key)}>
                      {column.render
                        ? column.render(row[column.key], row)
                        : String(row[column.key] ?? '')}
                    </TableCell>
                  ))}
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </div>

      {/* Pagination */}
      {totalPages > 1 && (
        <div className="flex items-center justify-between">
          <p className="text-sm text-muted-foreground">
            Showing {((currentPage - 1) * rowsPerPage) + 1} to{' '}
            {Math.min(currentPage * rowsPerPage, sortedData.length)} of{' '}
            {sortedData.length} results
          </p>
          <div className="flex items-center space-x-2">
            <Button
              variant="outline"
              size="sm"
              onClick={() => handlePageChange(currentPage - 1)}
              disabled={currentPage === 1}
            >
              <ChevronLeft className="h-4 w-4" />
              Previous
            </Button>
            <div className="flex items-center space-x-1">
              {Array.from({ length: Math.min(5, totalPages) }, (_, i) => {
                let pageNumber;
                if (totalPages <= 5) {
                  pageNumber = i + 1;
                } else if (currentPage <= 3) {
                  pageNumber = i + 1;
                } else if (currentPage >= totalPages - 2) {
                  pageNumber = totalPages - 4 + i;
                } else {
                  pageNumber = currentPage - 2 + i;
                }
                
                return (
                  <Button
                    key={pageNumber}
                    variant={currentPage === pageNumber ? 'default' : 'outline'}
                    size="sm"
                    onClick={() => handlePageChange(pageNumber)}
                  >
                    {pageNumber}
                  </Button>
                );
              })}
            </div>
            <Button
              variant="outline"
              size="sm"
              onClick={() => handlePageChange(currentPage + 1)}
              disabled={currentPage === totalPages}
            >
              Next
              <ChevronRight className="h-4 w-4" />
            </Button>
          </div>
        </div>
      )}
    </div>
  );
}
```

## Usage Example

```typescript
interface User {
  id: string;
  name: string;
  email: string;
  role: string;
  createdAt: string;
  status: 'active' | 'inactive';
}

const columns: Column<User>[] = [
  {
    key: 'name',
    header: 'Name',
    sortable: true,
    filterable: true,
  },
  {
    key: 'email',
    header: 'Email',
    sortable: true,
    filterable: true,
  },
  {
    key: 'role',
    header: 'Role',
    sortable: true,
    filterable: true,
  },
  {
    key: 'status',
    header: 'Status',
    sortable: true,
    render: (status) => (
      <span className={`px-2 py-1 rounded text-xs ${
        status === 'active' ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'
      }`}>
        {status}
      </span>
    ),
  },
  {
    key: 'createdAt',
    header: 'Created',
    sortable: true,
    render: (date) => new Date(date).toLocaleDateString(),
  },
];

export function UsersTable() {
  const [selectedUsers, setSelectedUsers] = useState<User[]>([]);
  const { data, loading } = useUsers(); // Your data fetching hook

  return (
    <DataTable
      data={data}
      columns={columns}
      loading={loading}
      selectable
      searchable
      onSelectionChange={setSelectedUsers}
      emptyMessage="No users found"
    />
  );
}
```

## Tests

```typescript
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { DataTable } from './DataTable';

const mockData = [
  { id: '1', name: 'John Doe', email: 'john@example.com' },
  { id: '2', name: 'Jane Smith', email: 'jane@example.com' },
  // ... more test data
];

const columns = [
  { key: 'name', header: 'Name', sortable: true, filterable: true },
  { key: 'email', header: 'Email', sortable: true, filterable: true },
];

describe('DataTable', () => {
  it('renders data correctly', () => {
    render(<DataTable data={mockData} columns={columns} />);
    
    expect(screen.getByText('John Doe')).toBeInTheDocument();
    expect(screen.getByText('jane@example.com')).toBeInTheDocument();
  });

  it('filters data based on search term', async () => {
    render(<DataTable data={mockData} columns={columns} searchable />);
    
    const searchInput = screen.getByPlaceholderText('Search...');
    fireEvent.change(searchInput, { target: { value: 'john' } });
    
    await waitFor(() => {
      expect(screen.getByText('John Doe')).toBeInTheDocument();
      expect(screen.queryByText('Jane Smith')).not.toBeInTheDocument();
    });
  });

  it('sorts data when column header is clicked', () => {
    render(<DataTable data={mockData} columns={columns} />);
    
    const nameHeader = screen.getByText('Name');
    fireEvent.click(nameHeader);
    
    // Verify ascending sort
    const rows = screen.getAllByRole('row');
    expect(rows[1]).toHaveTextContent('Jane Smith');
    expect(rows[2]).toHaveTextContent('John Doe');
  });
});
```

## Variations

### With Row Actions
```typescript
const columnsWithActions: Column<User>[] = [
  ...columns,
  {
    key: 'actions' as any,
    header: 'Actions',
    render: (_, row) => (
      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <Button variant="ghost" size="sm">
            <MoreHorizontal className="h-4 w-4" />
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent>
          <DropdownMenuItem onClick={() => handleEdit(row)}>
            Edit
          </DropdownMenuItem>
          <DropdownMenuItem onClick={() => handleDelete(row)}>
            Delete
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
    ),
  },
];
```

### With Custom Filters
```typescript
// Add column-specific filters
interface ColumnWithFilter<T> extends Column<T> {
  filterType?: 'text' | 'select' | 'date';
  filterOptions?: { label: string; value: string }[];
}
```

### With Virtual Scrolling
```typescript
// For large datasets, use react-window
import { FixedSizeList } from 'react-window';
```