import { Tenant } from './tenant';

export interface Property {
    id: number;
    name: string;
    description?: string;
    location: string;
    price: {
        amount: number;
        currency: string;
    };
    tenants: Tenant[];
    monthly_revenue: {
        amount: number;
        currency: string;
    };
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
