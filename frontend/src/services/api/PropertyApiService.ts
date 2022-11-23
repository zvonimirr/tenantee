import { PropertyDto, PropertyList } from '../../types/property';
import { HttpService } from './HttpService';

export class PropertyApiService extends HttpService {
    public static readonly listPropertiesPath = () => '/api/properties';
    public static readonly addNewPropertyPath = () => '/api/properties';
    public static readonly updatePropertyPath = (id: number) =>
        `/api/properties/${id}`;
    public static readonly deletePropertyPath = (id: number) =>
        `/api/properties/${id}`;

    async getProperties(path: string) {
        return HttpService.get<PropertyList>(path);
    }

    async addNewProperty(path: string, property: PropertyDto) {
        return HttpService.post<PropertyDto>(path, property);
    }

    async updateProperty(path: string, property: PropertyDto) {
        return HttpService.patch<PropertyDto>(path, property);
    }

    async deleteProperty(path: string) {
        return HttpService.delete(path);
    }
}

export const propertyApiService = new PropertyApiService();
