import { Preference, Preferences } from '../../types/preferences';
import { HttpService } from './HttpService';

export class PreferenceApiService implements HttpService {
    public static readonly listPreferencesPath = () => '/api/preferences';
    public static readonly setPreferencePath = () => '/api/preferences';

    public async getPreferences(path: string) {
        return HttpService.get<Preferences>(path);
    }

    public async setPreference(path: string, preference: Preference) {
        return HttpService.put<Preference>(path, preference);
    }
}

export const preferenceApiService = new PreferenceApiService();
