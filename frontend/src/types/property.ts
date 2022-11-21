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
}

export interface PropertyList {
    properties: Property[];
}
