import {
    Box,
    Button,
    Center,
    Grid,
    GridItem,
    Spinner,
    Stack,
    Text,
    useDisclosure,
} from '@chakra-ui/react';
import Breadcrumbs from '../components/Navigation/Breadcrumbs';
import PageContainer from '../components/PageContainer';
import useSWR from 'swr';
import {
    propertyApiService,
    PropertyApiService,
} from '../services/api/PropertyApiService';
import { Property, PropertyDto, PropertyList } from '../types/property';
import PropertyCard from '../components/Property/PropertyCard';
import { useNavigate } from 'react-router-dom';
import { useCallback, useEffect, useMemo, useState } from 'react';
import AddPropertyModal from '../components/Property/Modals/AddPropertyModal';
import ConfirmModal from '../components/Modals/ConfirmModal';
import { useNotification } from '../hooks/useNotification';

function Properties() {
    const { data, error, isValidating, mutate } = useSWR<PropertyList>(
        PropertyApiService.listPropertiesPath,
        propertyApiService.getProperties,
    );
    const navigate = useNavigate();
    const [propertyToDelete, setPropertyToDelete] = useState<Property | null>(
        null,
    );
    const {
        isOpen: isAddNewPropertyModalOpen,
        onOpen: openAddNewPropertyModal,
        onClose: closeAddNewPropertyModal,
    } = useDisclosure();
    const {
        isOpen: isConfirmModalOpen,
        onOpen: openConfirmModal,
        onClose: closeConfirmModal,
    } = useDisclosure();
    const { showError, showSuccess } = useNotification();

    const isLoading = useMemo(
        () => data === undefined || (isValidating && error !== undefined),
        [data, isValidating, error],
    );

    const isError = useMemo(() => error !== undefined, [error]);

    const onSubmit = useCallback(
        async (property: PropertyDto) => {
            try {
                await propertyApiService.addNewProperty(
                    PropertyApiService.addNewPropertyPath(),
                    property,
                );

                showSuccess(
                    'Property added',
                    'New property has been added successfully',
                );
            } catch (e) {
                showError(
                    'Error',
                    'An error occurred while trying to add new property',
                );
            } finally {
                mutate();
                closeAddNewPropertyModal();
            }
        },
        [mutate],
    );

    const onPropertyCardClick = useCallback(
        (property: Property) => navigate(`/properties/${property.id}`),
        [navigate],
    );

    const onPropertyDeleteClick = useCallback(async () => {
        if (propertyToDelete) {
            try {
                await propertyApiService.deleteProperty(
                    PropertyApiService.deletePropertyPath(propertyToDelete.id),
                );

                showSuccess(
                    'Property deleted',
                    `${propertyToDelete.name} has been deleted successfully`,
                );
            } catch (e) {
                showError(
                    'Error',
                    `An error occurred while trying to delete ${propertyToDelete.name}`,
                );
            } finally {
                setPropertyToDelete(null);
                mutate();
                closeConfirmModal();
            }
        }
    }, [mutate, propertyToDelete]);

    useEffect(() => {
        if (isError) {
            showError(
                'Error',
                'An error occurred while trying to load your properties',
            );
        }
    }, [isError]);

    return (
        <Box>
            <ConfirmModal
                isOpen={isConfirmModalOpen}
                title="Delete Property"
                message={`Are you sure you want to delete ${propertyToDelete?.name}?`}
                onConfirm={onPropertyDeleteClick}
                onCancel={closeConfirmModal}
            />
            <AddPropertyModal
                isOpen={isAddNewPropertyModalOpen}
                onClose={closeAddNewPropertyModal}
                onSubmit={onSubmit}
            />
            <Breadcrumbs
                items={[{ href: '/properties', label: 'Properties' }]}
            />
            <PageContainer>
                <Text fontSize="2xl">Your Properties</Text>
                <Stack spacing={4}>
                    <Grid templateColumns="repeat(3, 1fr)" gap={6}>
                        {isLoading && (
                            <GridItem colSpan={3}>
                                <Center>
                                    <Spinner size="lg" />
                                </Center>
                            </GridItem>
                        )}
                        {!isError &&
                            !isLoading &&
                            data &&
                            data.properties.map((property) => (
                                <GridItem key={property.id}>
                                    <PropertyCard
                                        property={property}
                                        onClick={onPropertyCardClick}
                                        onDeleteClick={(property) => {
                                            setPropertyToDelete(property);
                                            openConfirmModal();
                                        }}
                                    />
                                </GridItem>
                            ))}
                    </Grid>
                    <Center>
                        <Button
                            colorScheme="teal"
                            width="sm"
                            onClick={openAddNewPropertyModal}
                            disabled={isLoading}>
                            Add New Property
                        </Button>
                    </Center>
                </Stack>
            </PageContainer>
        </Box>
    );
}

export default Properties;
