import { useMemo } from 'react';
import useSWR, { Fetcher } from 'swr';

export function useFetch<T, K>(
    url: string | null,
    fetcher: Fetcher<T>,
    key: keyof T | null = null,
) {
    const { data, error, isValidating, mutate } = useSWR<T>(url, fetcher);

    const isLoading = useMemo(
        () => data === undefined || (isValidating && error !== undefined),
        [data, error, isValidating],
    );

    const isError = useMemo(() => error !== undefined, [error]);

    const result = useMemo(() => {
        if (isError || isLoading || !data) {
            return undefined;
        }

        if (key) {
            return data[key] as K;
        }

        return data as K;
    }, [data, key, isError, isLoading]);

    return {
        result,
        isLoading,
        isError,
        mutate,
    };
}
