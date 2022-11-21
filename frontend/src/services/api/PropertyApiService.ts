import { PropertyDto, PropertyList } from '../../types/property';
import { HttpService } from './HttpService';

export class PropertyApiService extends HttpService {
    public static readonly listPropertiesPath = () => '/api/properties';
    public static readonly addNewPropertyPath = () => '/api/properties';

    async getProperties(path: string) {
        return HttpService.get<PropertyList>(path);
    }

    async addNewProperty(path: string, property: PropertyDto) {
        return HttpService.post<PropertyDto>(path, property);
    }
}

export const propertyApiService = new PropertyApiService();
