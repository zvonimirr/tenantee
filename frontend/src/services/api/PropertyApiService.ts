import {
    Property,
    PropertyDto,
    PropertyList,
    PropertyUpdateDto,
} from '../../types/property';
import { HttpService } from './HttpService';

export class PropertyApiService extends HttpService {
    public static readonly listPropertiesPath = () => '/api/properties';
    public static readonly addNewPropertyPath = () => '/api/properties';
    public static readonly getPropertyPath = (id: number) =>
        `/api/properties/${id}`;
    public static readonly updatePropertyPath = (id: number) =>
        `/api/properties/${id}`;
    public static readonly deletePropertyPath = (id: number) =>
        `/api/properties/${id}`;
    public static readonly addTenantToPropertyPath = (
        propertyId: number,
        tenantId: number,
    ) => `/api/properties/${propertyId}/tenants/${tenantId}`;
    public static readonly removeTenantFromPropertyPath = (
        propertyId: number,
        tenantId: number,
    ) => `/api/properties/${propertyId}/tenants/${tenantId}`;

    async getProperties(path: string) {
        return HttpService.get<PropertyList>(path);
    }

    async getProperty(path: string) {
        return HttpService.get<Property>(path);
    }

    async addNewProperty(path: string, property: PropertyDto) {
        return HttpService.post<PropertyDto>(path, property);
    }

    async updateProperty(path: string, property: PropertyUpdateDto) {
        return HttpService.patch<PropertyDto>(path, property);
    }

    async deleteProperty(path: string) {
        return HttpService.delete(path);
    }

    async addTenantToProperty(path: string) {
        return HttpService.put(path, {});
    }

    async removeTenantFromProperty(path: string) {
        return HttpService.delete(path);
    }
}

export const propertyApiService = new PropertyApiService();
