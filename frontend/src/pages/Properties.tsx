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
import { useCallback, useMemo } from 'react';
import AddPropertyModal from '../components/Property/Modals/AddPropertyModal';

function Properties() {
    const { data, error, isValidating, mutate } = useSWR<PropertyList>(
        PropertyApiService.listPropertiesPath,
        propertyApiService.getProperties,
    );
    const navigate = useNavigate();
    const { isOpen, onOpen, onClose } = useDisclosure();

    const isLoading = useMemo(
        () => data === undefined || (isValidating && error !== undefined),
        [data, isValidating, error],
    );

    const isError = useMemo(() => error !== undefined, [error]);

    const onSubmit = useCallback(
        async (property: PropertyDto) => {
            await propertyApiService.addNewProperty(
                PropertyApiService.addNewPropertyPath(),
                property,
            );
            mutate();
            onClose();
        },
        [mutate],
    );

    const onPropertyCardClick = useCallback(
        (property: Property) => navigate(`/properties/${property.id}`),
        [navigate],
    );

    return (
        <Box>
            <AddPropertyModal
                isOpen={isOpen}
                onClose={onClose}
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
                        {isError && (
                            <GridItem colSpan={3}>
                                <Center>
                                    <Text>
                                        There was an error loading your
                                        properties.
                                    </Text>
                                </Center>
                            </GridItem>
                        )}
                        {data &&
                            data.properties.map((property) => (
                                <GridItem key={property.id}>
                                    <PropertyCard
                                        property={property}
                                        onClick={onPropertyCardClick}
                                    />
                                </GridItem>
                            ))}
                    </Grid>
                    <Button onClick={onOpen} disabled={isLoading}>
                        Add New Property
                    </Button>
                </Stack>
            </PageContainer>
        </Box>
    );
}

export default Properties;
