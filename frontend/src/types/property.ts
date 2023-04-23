import { Tenant } from './tenant';

interface Price {
    amount: number;
    currency: string;
}

export interface Property {
    id: number;
    name: string;
    description?: string;
    location: string;
    price: Price;
    tenants: Tenant[];
    monthly_revenue: Price;
    expenses: {
        amount: Price;
        date: Date;
    }[];
    due_date_modifier: number;
    tax_percentage: number;
}

export interface PropertyList {
    properties: Property[];
}

export interface PropertyDto
    extends Omit<
        Property,
        'id' | 'price' | 'tenants' | 'monthly_revenue' | 'expenses'
    > {
    price: number;
}

export interface PropertyUpdateDto extends PropertyDto {
    id: number;
}

export function calculateDueDateModifier(days: number): number {
    return days * 60 * 60 * 24;
}

export function getNumberOfDaysFromDueDateModifier(
    due_date_modifier: number,
): number {
    if (due_date_modifier === 0) {
        return 0;
    }

    return due_date_modifier / (60 * 60 * 24);
}
