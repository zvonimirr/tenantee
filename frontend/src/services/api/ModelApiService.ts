import { HttpService } from './HttpService';

type ModelList<T, N extends string> = Listable<T, Plural<N>>;

type Args<T> = [string, T];

type Id = string | number;

type NewModel<T> =  Omit<T, 'id'>;

export abstract class ModelApiService<T, N extends string, K = T> extends HttpService {
    public abstract apiRoute: string;

    async get(...[url, id]: Args<Id>): Promise<T> {
        return HttpService.get(`${url}/${id}`);
    }

    async add(...[url, body]: Args<NewModel<K>>): Promise<K> {
        return HttpService.post(url, body);
    }

    async update(...[url, body]: Args<K>): Promise<K> {
        return HttpService.patch(url, body);
    }

    async delete(...[url, id]: Args<Id>): Promise<void> {
        return HttpService.delete(`${url}/${id}`);
    }

    async list(url: string): Promise<ModelList<T, N>> {
        console.log(`list() called on ${url}`);
        return HttpService.get(url);
    }
}