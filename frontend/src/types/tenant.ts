import { Property } from './property';
import { Rent } from './rent';

export interface Communication {
    id: string;
    type: string;
    value: string;
}

export interface Tenant {
    id: number;
    name: string;
    email?: string;
    phone?: string;
    unpaid_rents: Rent[];
    properties: Property[];
    communications: Communication[];
}

export interface TenantList {
    tenants: Tenant[];
}

export interface TenantDto
    extends Omit<Tenant, 'id' | 'name' | 'properties' | 'unpaid_rents'> {
    first_name: string;
    last_name: string;
}

export interface TenantUpdateDto extends TenantDto {
    id: number;
}
