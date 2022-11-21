import { useToast } from '@chakra-ui/react';
import { useCallback } from 'react';

export function useNotification() {
    const toast = useToast();

    const showSuccess = useCallback(
        (title: string, description: string) =>
            toast({
                title,
                description,
                status: 'success',
                duration: 5000,
                isClosable: true,
            }),
        [toast],
    );

    const showError = useCallback(
        (title: string, description: string) =>
            toast({
                title,
                description,
                status: 'error',
                duration: 5000,
                isClosable: true,
            }),
        [toast],
    );

    return {
        showSuccess,
        showError,
    };
}
