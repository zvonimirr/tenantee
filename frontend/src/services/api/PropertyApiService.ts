import { Property, PropertyUpdateDto } from '../../types/property';
import { HttpService } from './HttpService';
import { ModelApiService } from './ModelApiService';

export class PropertyApiService extends ModelApiService<Property, 'property', PropertyUpdateDto> {
    public apiRoute = '/api/properties';

    async addTenant(propertyId: Id, tenantId: Id) {
        return HttpService.put(`${this.apiRoute}/${propertyId}/tenants/${tenantId}`, {});
    }

    async removeTenant(propertyId: Id, tenantId: Id) {
        return HttpService.delete(`${this.apiRoute}/${propertyId}/tenants/${tenantId}`);
    }
}

export const propertyApiService = new PropertyApiService();