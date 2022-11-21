import { PropertyList } from '../../types/property';
import { HttpService } from './HttpService';

export class PropertyApiService extends HttpService {
    public static readonly listPropertiesPath = () => '/api/properties';

    async getProperties(path: string) {
        return HttpService.get<PropertyList>(path);
    }
}

export const propertyApiService = new PropertyApiService();
