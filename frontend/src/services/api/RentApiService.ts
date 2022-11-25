import { RentList } from '../../types/rent';
import { HttpService } from './HttpService';

export class RentApiService extends HttpService {
    public static readonly markRentPath = (id: number, paid: boolean) => `/api/rents/${id}/mark-as-${paid ? 'paid' : 'unpaid'}`;
    public static readonly getRentsByTenantIdPath = (tenantId: number) => `/api/tenants/${tenantId}/rents`;

    async updateRent(path: string) {
        return HttpService.post(path, {});
    }

    async getRents(path: string) {
        return HttpService.get<RentList>(path);
    }
}

export const rentApiService = new RentApiService();
