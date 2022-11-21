import { createContext, ReactNode, useContext, useState } from 'react';

interface DrawerProviderProps {
    children: ReactNode;
}

interface DrawerContextProps {
    isOpen: boolean;
    openDrawer: () => void;
    closeDrawer: () => void;
}

const DrawerContext = createContext<DrawerContextProps>({
    isOpen: false,
    openDrawer: () => {},
    closeDrawer: () => {},
});

function DrawerProvider({ children }: DrawerProviderProps) {
    const [isOpen, setIsOpen] = useState<boolean>(false);

    const openDrawer = () => setIsOpen(() => true);
    const closeDrawer = () => setIsOpen(() => false);

    return (
        <DrawerContext.Provider
            value={{
                isOpen,
                openDrawer,
                closeDrawer,
            }}>
            {children}
        </DrawerContext.Provider>
    );
}

export const useDrawer = () => useContext(DrawerContext);

export default DrawerProvider;
