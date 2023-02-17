import ConfirmModal from '../../../src/components/Modals/ConfirmModal';

describe('ConfirmModal.cy.tsx', () => {
    it('should render properly', () => {
        cy.mount(
            <ConfirmModal
                title="Cypress"
                message="Cypress is awesome"
                isOpen={true}
                onClose={() => {}}
                onConfirm={() => {}}
            />,
        );

        cy.get('header').should('contain', 'Cypress');
        cy.get('p').should('contain', 'Cypress is awesome');

        cy.get('button').should('have.length', 3);
        cy.get('button').eq(1).should('contain', 'Confirm');
        cy.get('button').last().should('contain', 'Cancel');
    });

    it('should call onClose when cancel button is clicked', () => {
        const onClose = cy.stub();

        cy.mount(
            <ConfirmModal
                title="Cypress"
                message="Cypress is awesome"
                isOpen={true}
                onClose={onClose}
                onConfirm={() => {}}
            />,
        );

        cy.get('button').last().click();

        cy.wrap(onClose).should('have.been.calledOnce');
    });

    it('should call onConfirm when confirm button is clicked', () => {
        const onConfirm = cy.stub();

        cy.mount(
            <ConfirmModal
                title="Cypress"
                message="Cypress is awesome"
                isOpen={true}
                onClose={() => {}}
                onConfirm={onConfirm}
            />,
        );

        cy.get('button').eq(1).click();

        cy.wrap(onConfirm).should('have.been.calledOnce');
    });
});
