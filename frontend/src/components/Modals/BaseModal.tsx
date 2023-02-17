import {
    Modal,
    ModalBody,
    ModalCloseButton,
    ModalContent,
    ModalHeader,
    ModalOverlay,
} from '@chakra-ui/react';
import { PropsWithChildren, RefObject } from 'react';

export interface BaseModalProps {
    title: string;
    isOpen: boolean;
    initialFocusRef?: RefObject<HTMLElement>;
    onClose: () => void;
}

function BaseModal({
    title,
    isOpen,
    onClose,
    initialFocusRef,
    children,
}: PropsWithChildren<BaseModalProps>) {
    return (
        <Modal
            onClose={onClose}
            isOpen={isOpen}
            initialFocusRef={initialFocusRef}>
            <ModalOverlay />
            <ModalContent>
                <ModalHeader>{title}</ModalHeader>
                <ModalCloseButton />
                <ModalBody>{children}</ModalBody>
            </ModalContent>
        </Modal>
    );
}

export default BaseModal;
