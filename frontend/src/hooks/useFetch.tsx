import { useEffect } from 'react';
import useSWR, { Fetcher, Key } from 'swr';

type FetcherUrl = string | [...unknown[]] | null;

interface UseFetchOptions {
    onError?: (error: Error) => void;
}

function resolveUrl(arg: FetcherUrl): Key {
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
    const response = useSWR<T>(resolveUrl(url), fetcher);
    const { onError } = options;

    useEffect(() => {
        if (onError instanceof Function && response.error instanceof Error) {
            onError(response.error);
        }
    }, [response.error, onError]);

    return { ...response, isError: response.error instanceof Error };
}
