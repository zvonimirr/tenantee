import ConfirmModal from '../../src/components/Modals/ConfirmModal';

describe('ConfirmModal.cy.ts', () => {
    it('should render properly', () => {
        cy.mount(
            <ConfirmModal
                title="Cypress"
                message="Cypress is awesome"
                isOpen={true}
                onCancel={() => {}}
                onConfirm={() => {}}
            />,
        );

        cy.get('header').should('contain', 'Cypress');
        cy.get('p').should('contain', 'Cypress is awesome');

        cy.get('button').should('have.length', 3);
        cy.get('button').eq(1).should('contain', 'Confirm');
        cy.get('button').last().should('contain', 'Cancel');
    });

    it('should call onCancel when cancel button is clicked', () => {
        const onCancel = cy.stub();

        cy.mount(
            <ConfirmModal
                title="Cypress"
                message="Cypress is awesome"
                isOpen={true}
                onCancel={onCancel}
                onConfirm={() => {}}
            />,
        );

        cy.get('button').last().click();

        cy.wrap(onCancel).should('have.been.calledOnce');
    });

    it('should call onConfirm when confirm button is clicked', () => {
        const onConfirm = cy.stub();

        cy.mount(
            <ConfirmModal
                title="Cypress"
                message="Cypress is awesome"
                isOpen={true}
                onCancel={() => {}}
                onConfirm={onConfirm}
            />,
        );

        cy.get('button').eq(1).click();

        cy.wrap(onConfirm).should('have.been.calledOnce');
    });
});
