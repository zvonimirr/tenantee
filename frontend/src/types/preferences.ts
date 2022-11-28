type PreferecnceName = 'name' | 'open_exchange_app_id' | 'default_currency';

export interface Preference {
    name: PreferecnceName;
    value: string;
}

export interface Preferences {
    preferences: Preference[];
}
