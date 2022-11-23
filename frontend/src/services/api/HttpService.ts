export class HttpService {
    static async get<T>(url: string): Promise<T> {
        const response = await fetch(`${import.meta.env.VITE_API_URL}${url}`);
        return await response.json();
    }

    static async post<T>(url: string, body: T): Promise<T> {
        const response = await fetch(`${import.meta.env.VITE_API_URL}${url}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(body),
        });
        return await response.json();
    }

    static async put<T>(url: string, body: T): Promise<T> {
        const response = await fetch(`${import.meta.env.VITE_API_URL}${url}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(body),
        });
        return await response.json();
    }

    static async patch<T>(url: string, body: T): Promise<T> {
        const response = await fetch(`${import.meta.env.VITE_API_URL}${url}`, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(body),
        });
        return await response.json();
    }

    static async delete(url: string): Promise<void> {
        await fetch(`${import.meta.env.VITE_API_URL}${url}`, {
            method: 'DELETE',
        });
    }
}
