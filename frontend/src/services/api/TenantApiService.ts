import { Tenant, TenantUpdateDto } from '../../types/tenant';
import { HttpService } from './HttpService';
import { ModelApiCallbackArgs, ModelApiService } from './ModelApiService';
import { RentApiService } from './RentApiService';

export class TenantApiService extends ModelApiService<Tenant, 'tenant', TenantUpdateDto> {
    public apiRoute = '/api/tenants';

    async rents([url, ...rest]: ModelApiCallbackArgs): ReturnType<RentApiService['list']> {
        const [id] = rest;
        return HttpService.get(`${url}/${id}/rents`);
    }
}

export const tenantApiService = new TenantApiService();
