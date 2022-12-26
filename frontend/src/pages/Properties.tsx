import { Box, Button, Center, Grid, GridItem, Spinner, Stack, Text, useDisclosure } from '@chakra-ui/react';
import { useCallback, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import ConfirmModal from '../components/Modals/ConfirmModal';
import Breadcrumbs from '../components/Navigation/Breadcrumbs';
import PageContainer from '../components/PageContainer';
import AddPropertyModal from '../components/Property/Modals/AddPropertyModal';
import EditPropertyModal from '../components/Property/Modals/EditPropertyModal';
import PropertyCard from '../components/Property/PropertyCard';
import { useFetch } from '../hooks/useFetch';
import { useNotification } from '../hooks/useNotification';
import { propertyApiService } from '../services/api/PropertyApiService';
import { Property, PropertyDto, PropertyUpdateDto } from '../types/property';

function Properties() {
    const {
        data: { properties } = { properties: [] },
        isLoading,
        mutate,
    } = useFetch(
        propertyApiService.apiRoute,
        propertyApiService.list
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

    const onPropertyCardClick = useCallback(
        (property: Property) => navigate(`/properties/${property.id}`),
        [navigate],
    );

    const onAddPropertySubmit = useCallback(
        async (property: PropertyDto) => {
            try {
                await propertyApiService.add(
                    propertyApiService.apiRoute,
                    property
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
        [closeAddNewPropertyModal, mutate, showError, showSuccess],
    );

    const onEditPropertySubmit = useCallback(
        async (property: PropertyUpdateDto) => {
            try {
                await propertyApiService.update(
                    propertyApiService.apiRoute,
                    property,
                );

                showSuccess(
                    'Property updated',
                    `Property ${property.name} has been updated successfully`,
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
        [closeEditPropertyModal, mutate, selectedProperty?.name, showError, showSuccess],
    );

    const onPropertyDeleteClick = useCallback(async () => {
        if (selectedProperty) {
            try {
                await propertyApiService.delete(propertyApiService.apiRoute, selectedProperty.id);

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
    }, [closeConfirmModal, mutate, selectedProperty, showError, showSuccess]);

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
                        {properties.map((property) => (
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
                        {!properties.length && (
                            <GridItem colSpan={3}>
                                <Text fontSize="lg" textAlign="center">
                                    {
                                        'You don\'t have any properties yet. Click the button below to add one.'
                                    }
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
