import { ChakraProvider } from '@chakra-ui/react';
import Navigation from './Navigation/Navigation';
import { createBrowserRouter, RouterProvider } from 'react-router-dom';
import Home from '../pages/Home';
import DrawerProvider from '../hooks/useDrawer';
import {
    IconHome,
    IconKey,
    IconSettings,
    IconUsers,
} from '@tabler/icons-react';
import Label from './Navigation/Label';
import { SWRConfig } from 'swr';
import Properties from '../pages/Properties';
import Tenants from '../pages/Tenants';
import Property from '../pages/Property';
import Tenant from '../pages/Tenant';
import Settings from '../pages/Settings';

const links = [
    {
        href: '/',
        label: <Label icon={<IconHome />} label="Home" />,
    },
    {
        href: '/properties',
        label: <Label icon={<IconKey />} label="Properties" />,
    },
    {
        href: '/tenants',
        label: <Label icon={<IconUsers />} label="Tenants" />,
    },
    {
        href: '/settings',
        label: <Label icon={<IconSettings />} label="Settings" />,
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
        path: '/properties/:id',
        element: <Property />,
    },
    {
        path: '/tenants',
        element: <Tenants />,
    },
    {
        path: '/tenants/:id',
        element: <Tenant />,
    },
    {
        path: '/settings',
        element: <Settings />,
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
