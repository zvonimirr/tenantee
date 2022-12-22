import { useEffect } from 'react';
import useSWR, { Fetcher } from 'swr';

type FetcherUrl = string | [...unknown[]] | null;

interface UseFetchOptions {
    onError?: (error: Error) => void;
}

function resolveUrl(arg: FetcherUrl): [string?, ...unknown[]] {
    if (arg === null || (Array.isArray(arg) && !arg.length)) {
        return [];
    }

    if (typeof arg === 'string') {
        return [arg];
    }

    return arg;
}

export function useFetch<T = ReturnType<Fetcher>>(
    url: FetcherUrl = [],
    fetcher: Fetcher<T>,
    options: UseFetchOptions = {},
) {
    const { error, ...rest } = useSWR<T>(resolveUrl(url), fetcher);
    const { onError } = options;

    useEffect(() => {
        if (onError instanceof Function && error instanceof Error) {
            onError(error);
        }
    }, [onError]);

    return rest;
}
