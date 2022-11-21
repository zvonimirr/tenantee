import { ChakraProvider } from '@chakra-ui/react';
import Navigation from './Navigation/Navigation';
import { createBrowserRouter, RouterProvider } from 'react-router-dom';
import Home from '../pages/Home';
import DrawerProvider from '../hooks/useDrawer';
import { IconKey, IconUsers } from '@tabler/icons';
import Label from './Navigation/Label';
import { SWRConfig } from 'swr';
import Properties from '../pages/Properties';
import Tenants from '../pages/Tenants';

const links = [
    {
        href: '/properties',
        label: <Label icon={<IconKey />} label="Properties" />,
    },
    {
        href: '/tenants',
        label: <Label icon={<IconUsers />} label="Tenants" />,
    },
];

const router = createBrowserRouter([
    {
        path: '/',
        element: <Home />,
    },
    {
        path: '/properties',
        element: <Properties />,
    },
    {
        path: '/tenants',
        element: <Tenants />,
    },
]);

function App() {
    return (
        <ChakraProvider>
            <DrawerProvider>
                <Navigation links={links} />
                <SWRConfig
                    value={{
                        revalidateOnFocus: false,
                    }}>
                    <RouterProvider router={router} />
                </SWRConfig>
            </DrawerProvider>
        </ChakraProvider>
    );
}

export default App;
