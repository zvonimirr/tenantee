export class HttpService {
    static async get<T>(url: string): Promise<T> {
        const response = await fetch(`${import.meta.env.VITE_API_URL}${url}`);
        return await response.json();
    }
}
