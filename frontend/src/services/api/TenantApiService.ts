import { TenantList } from '../../types/tenant';
import { HttpService } from './HttpService';

export class TenantApiService {
    public static readonly listTenantsPath = () => '/api/tenants';

    async getTenants(path: string) {
        return HttpService.get<TenantList>(path);
    }
}

export const tenantApiService = new TenantApiService();
