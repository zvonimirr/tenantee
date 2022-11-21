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
import { useToast } from '@chakra-ui/react';

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
    const toast = useToast();

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

                toast({
                    title: 'Property added',
                    description: 'New property has been added successfully',
                    status: 'success',
                    duration: 5000,
                    isClosable: true,
                });
            } catch (e) {
                toast({
                    title: 'Error',
                    description:
                        'An error occurred while trying to add new property',
                    status: 'error',
                    duration: 5000,
                    isClosable: true,
                });
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

                toast({
                    title: 'Property deleted',
                    description: `Successfully deleted property ${propertyToDelete.name}`,
                    status: 'success',
                    duration: 5000,
                    isClosable: true,
                });
            } catch (e) {
                toast({
                    title: 'Error',
                    description: `An error occurred while trying to delete the property ${propertyToDelete.name}`,
                    status: 'error',
                    duration: 5000,
                    isClosable: true,
                });
            } finally {
                setPropertyToDelete(null);
                mutate();
                closeConfirmModal();
            }
        }
    }, [mutate, propertyToDelete]);

    useEffect(() => {
        if (isError) {
            toast({
                title: 'Error',
                description:
                    'An error occurred while trying to load your properties',
                status: 'error',
                duration: 5000,
                isClosable: true,
            });
        }
    }, [isError]);

    return (
        <Box>
            <ConfirmModal
                isOpen={isConfirmModalOpen}
                title="Delete Property"
                message={`Are you sure you want to delete ${propertyToDelete?.name}?`}
                onConfirm={() => {
                    openConfirmModal();
                    onPropertyDeleteClick();
                }}
                onCancel={() => {
                    closeConfirmModal();
                }}
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
