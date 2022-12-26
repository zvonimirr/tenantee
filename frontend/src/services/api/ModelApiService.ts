import { HttpService } from './HttpService';

export type ModelList<T, N extends string> = Listable<T, Plural<N>>;

export type ModelApiCallbackArgs = [string, ...unknown[]];

type NewModel<T> =  Omit<T, 'id'>;

export abstract class ModelApiService<T, N extends string, K = T> {
    public abstract apiRoute: string;

    async get([url, ...rest]: ModelApiCallbackArgs): Promise<T> {
        const [id] = rest;

        if (typeof id !== 'string' && typeof id !== 'number') {
            throw new TypeError('Ivalid id type. Must be string or number.');
        }

        return HttpService.get(`${url}/${id}`);
    }

    async add(url: string, body: NewModel<K>): Promise<K> {
        return HttpService.post(url, body);
    }

    async update(url: string, body: K extends { id: Id } ? K : never): Promise<K> {
        return HttpService.patch(`${url}/${body.id}`, body);
    }

    async delete(url: string, id: Id): Promise<void> {
        return HttpService.delete(`${url}/${id}`);
    }

    async set(url: string, body: K): Promise<K> {
        return HttpService.put(url, body);
    }

    async list(url: string): Promise<ModelList<T, N>> {
        console.log(`list() called on ${url}`);
        return HttpService.get(url);
    }
}