import { Tenant, TenantUpdateDto } from '../../types/tenant';
import { ModelApiService } from './ModelApiService';

export class TenantApiService extends ModelApiService<Tenant, 'tenant', TenantUpdateDto> {
    public apiRoute = '/api/tenants';
}

export const tenantApiService = new TenantApiService();
