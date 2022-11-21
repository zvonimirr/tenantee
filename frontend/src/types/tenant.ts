export interface Tenant {
    id: number;
    name: string;
    email?: string;
    phone?: string;
}

export interface TenantList {
    tenants: Tenant[];
}

export interface TenantDto {
    tenant: Omit<Tenant, 'id' | 'name'> & {
        first_name: string;
        last_name: string;
    };
}
