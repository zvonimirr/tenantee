import { useEffect, useMemo } from 'react';
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

    // const { data, error, isValidating, mutate } = useSWR<T>(resolveUrl(url), fetcher);

    // const isLoading = useMemo(
    //     () => data === undefined || (isValidating && error !== undefined),
    //     [data, error, isValidating],
    // );

    // const isError = useMemo(() => error !== undefined, [error]);

    // const result = useMemo(() => {
    //     // if (isError || isLoading || !data) {
    //     //     return undefined;
    //     // }

    //     // if (key) {
    //     //     return data?.[key];
    //     // }

    //     return data;
    // }, [data, isError, isLoading]);

    // return {
    //     result,
    //     isLoading,
    //     isError,
    //     mutate,
    // };
}
