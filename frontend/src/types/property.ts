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
}

export interface PropertyList {
    properties: Property[];
}

export interface PropertyDto
    extends Omit<Property, 'id' | 'price' | 'tenants' | 'monthly_revenue'> {
    price: number;
}

export interface PropertyUpdateDto extends PropertyDto {
    id: number;
}
