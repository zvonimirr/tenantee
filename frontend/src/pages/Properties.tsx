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
import {
    Property,
    PropertyDto,
    PropertyList,
    PropertyUpdateDto,
} from '../types/property';
import PropertyCard from '../components/Property/PropertyCard';
import { useNavigate } from 'react-router-dom';
import { useCallback, useEffect, useMemo, useState } from 'react';
import AddPropertyModal from '../components/Property/Modals/AddPropertyModal';
import ConfirmModal from '../components/Modals/ConfirmModal';
import { useNotification } from '../hooks/useNotification';
import { isEmpty } from 'ramda';
import EditPropertyModal from '../components/Property/Modals/EditPropertyModal';

function Properties() {
    const { data, error, isValidating, mutate } = useSWR<PropertyList>(
        PropertyApiService.listPropertiesPath,
        propertyApiService.getProperties,
    );
    const navigate = useNavigate();
    const [selectedProperty, setSelectedProperty] = useState<Property | null>(
        null,
    );
    const {
        isOpen: isAddNewPropertyModalOpen,
        onOpen: openAddNewPropertyModal,
        onClose: closeAddNewPropertyModal,
    } = useDisclosure();
    const {
        isOpen: isEditPropertyModalOpen,
        onOpen: openEditPropertyModal,
        onClose: closeEditPropertyModal,
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

    const onPropertyCardClick = useCallback(
        (property: Property) => navigate(`/properties/${property.id}`),
        [navigate],
    );

    const onAddPropertySubmit = useCallback(
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

    const onEditPropertySubmit = useCallback(
        async (property: PropertyUpdateDto) => {
            try {
                await propertyApiService.updateProperty(
                    PropertyApiService.updatePropertyPath(property.id),
                    property,
                );

                showSuccess(
                    'Property updated',
                    `Property ${property.property.name} has been updated successfully`,
                );
            } catch (e) {
                showError(
                    'Error',
                    `An error occurred while trying to update ${selectedProperty?.name} property`,
                );
            } finally {
                setSelectedProperty(null);
                closeEditPropertyModal();
                mutate();
            }
        },
        [mutate, selectedProperty],
    );

    const onPropertyDeleteClick = useCallback(async () => {
        if (selectedProperty) {
            try {
                await propertyApiService.deleteProperty(
                    PropertyApiService.deletePropertyPath(selectedProperty.id),
                );

                showSuccess(
                    'Property deleted',
                    `${selectedProperty.name} has been deleted successfully`,
                );
            } catch (e) {
                showError(
                    'Error',
                    `An error occurred while trying to delete ${selectedProperty.name}`,
                );
            } finally {
                setSelectedProperty(null);
                mutate();
                closeConfirmModal();
            }
        }
    }, [mutate, selectedProperty]);

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
                message={`Are you sure you want to delete ${selectedProperty?.name}?`}
                onConfirm={onPropertyDeleteClick}
                onCancel={closeConfirmModal}
            />
            <AddPropertyModal
                isOpen={isAddNewPropertyModalOpen}
                onClose={closeAddNewPropertyModal}
                onSubmit={onAddPropertySubmit}
            />
            <EditPropertyModal
                isOpen={isEditPropertyModalOpen}
                onClose={closeEditPropertyModal}
                onSubmit={onEditPropertySubmit}
                property={selectedProperty}
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
                                            setSelectedProperty(property);
                                            openConfirmModal();
                                        }}
                                        onEditClick={(property) => {
                                            setSelectedProperty(property);
                                            openEditPropertyModal();
                                        }}
                                    />
                                </GridItem>
                            ))}
                        {!isError &&
                            !isLoading &&
                            data &&
                            isEmpty(data.properties) && (
                                <GridItem colSpan={3}>
                                    <Text fontSize="lg" textAlign="center">
                                        You don't have any properties yet. Click
                                        the button below to add one.
                                    </Text>
                                </GridItem>
                            )}
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
