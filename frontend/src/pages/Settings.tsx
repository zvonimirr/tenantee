import {
    Box,
    Button,
    Center,
    Checkbox,
    Flex,
    Spinner,
    Stack,
    useColorMode,
} from '@chakra-ui/react';
import { useCallback, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import GenericInput from '../components/Form/GenericInput';
import Breadcrumbs from '../components/Navigation/Breadcrumbs';
import PageContainer from '../components/PageContainer';
import {
    preferenceApiService,
    PreferenceApiService,
} from '../services/api/PreferenceApiService';
import { Preference, Preferences } from '../types/preferences';
import { difference } from 'ramda';
import { useNotification } from '../hooks/useNotification';
import CurrencySelect from '../components/Form/CurrencySelect';
import { useFetch } from '../hooks/useFetch';

interface PreferenceFormFields {
    name: string;
    open_exchange_app_id: string;
    default_currency: string;
}

function Settings() {
    const { colorMode, toggleColorMode } = useColorMode();
    const { showSuccess, showError } = useNotification();
    const { control, watch, setValue, reset, handleSubmit, formState } =
        useForm<PreferenceFormFields>({
            mode: 'onChange',
            defaultValues: {
                name: '',
                open_exchange_app_id: '',
                default_currency: '',
            },
        });

    const {
        result: preferences,
        isError,
        isLoading,
        mutate,
    } = useFetch<Preferences, Preference[]>(
        PreferenceApiService.listPreferencesPath(),
        preferenceApiService.getPreferences,
        'preferences',
    );

    const default_currency = watch('default_currency');

    useEffect(() => {
        if (preferences) {
            reset({
                name: preferences.find((p) => p.name === 'name')?.value ?? '',
                open_exchange_app_id:
                    preferences.find((p) => p.name === 'open_exchange_app_id')
                        ?.value ?? '',
                default_currency:
                    preferences.find((p) => p.name === 'default_currency')
                        ?.value ?? '',
            });
        }
    }, [preferences]);

    const onPreferenceChange = useCallback(async (preference: Preference) => {
        try {
            await preferenceApiService.setPreference(
                PreferenceApiService.setPreferencePath(),
                preference,
            );

            showSuccess(
                'Preference set',
                `Successfully set ${preference.name} to ${preference.value}`,
            );
        } catch {
            showError(
                'Error',
                `Error while trying to set ${preference.name} to ${preference.value}`,
            );
        }
    }, []);

    const onSaveClick = useCallback(
        async (values: PreferenceFormFields) => {
            if (preferences) {
                const preferenceValues: Preference[] = Object.entries(
                    values,
                ).map(([name, value]) => ({
                    name: name as Preference['name'],
                    value,
                }));

                const changed = difference(
                    preferenceValues,
                    preferences,
                ).filter((p) => p.value !== '');

                if (changed.length === 0) {
                    showSuccess('No changes', 'No changes to save');
                    return;
                }
                await Promise.all(
                    changed.map((p) =>
                        onPreferenceChange({
                            name: p.name as Preference['name'],
                            value: values[p.name as Preference['name']],
                        }),
                    ),
                );
                mutate();
            }
        },
        [preferences],
    );
    return (
        <Box>
            <Breadcrumbs items={[{ label: 'Settings', href: '/settings' }]} />
            <PageContainer>
                {isLoading && (
                    <Center>
                        <Spinner size="lg" />
                    </Center>
                )}
                {!isLoading && !isError && preferences && (
                    <Stack>
                        <GenericInput
                            name="name"
                            label="Name"
                            placeholder="Landlord name..."
                            control={control}
                            rules={{ required: 'Name can\'t be empty' }}
                        />
                        <GenericInput
                            name="open_exchange_app_id"
                            label="Open Exchange App ID"
                            placeholder="Open Exchange App ID..."
                            control={control}
                            rules={{
                                required: 'Open Exchange App ID can\'t be empty',
                            }}
                        />
                        <label htmlFor="default_currency">
                            Default Currency
                        </label>
                        <CurrencySelect
                            name="default_currency"
                            value={default_currency}
                            onChange={(value) => {
                                setValue('default_currency', value);
                            }}
                        />

                        <Flex direction="row" gap={2}>
                            <label htmlFor="dark_mode">Dark Mode</label>
                            <Checkbox
                                name="dark_mode"
                                size="lg"
                                colorScheme="teal"
                                defaultChecked={colorMode === 'dark'}
                                onChange={toggleColorMode}
                            />
                        </Flex>
                        <Button
                            colorScheme="teal"
                            onClick={handleSubmit(onSaveClick)}
                            disabled={
                                isLoading ||
                                !formState.isValid ||
                                formState.isSubmitting
                            }>
                            Save
                        </Button>
                    </Stack>
                )}
            </PageContainer>
        </Box>
    );
}

export default Settings;
