import { Preference } from '../../types/preferences';
import { ModelApiService } from './ModelApiService';

export class PreferenceApiService extends ModelApiService<Preference, 'preference'> {
    public apiRoute = '/api/preferences';
}
export const preferenceApiService = new PreferenceApiService();
