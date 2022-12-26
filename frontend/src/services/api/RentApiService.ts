import { Rent } from '../../types/rent';
import { HttpService } from './HttpService';
import { ModelApiService } from './ModelApiService';

export class RentApiService extends ModelApiService<Rent, 'rent'> {
    public apiRoute = '/api/rents';

    async mark(id: number, paid: boolean) {
        return HttpService.post(`${this.apiRoute}/${id}/mark-as-${paid ? 'paid' : 'unpaid'}`, {});
    }
}

export const rentApiService = new RentApiService();
