import AddPropertyModal from '../../../../src/components/Property/Modals/AddPropertyModal';

describe('AddPropertyModal', () => {
    it('should validate properly', () => {
        cy.mount(
            <AddPropertyModal
                isOpen={true}
                onClose={() => {}}
                onSubmit={() => {}}
            />,
        );

        cy.get('#submit').should('be.disabled');

        cy.get('input').each((input) => {
            cy.wrap(input).type('123');
        });

        cy.get('#submit').should('not.be.disabled');
    });

    it('should call onClose when close button is clicked', () => {
        const onClose = cy.stub();

        cy.mount(
            <AddPropertyModal
                isOpen={true}
                onClose={onClose}
                onSubmit={() => {}}
            />,
        );

        cy.get('button').first().click();
    });

    it('should submit properly', () => {
        const onSubmit = cy.stub();

        cy.mount(
            <AddPropertyModal
                isOpen={true}
                onClose={() => {}}
                onSubmit={onSubmit}
            />,
        );

        cy.get('input').each((input) => {
            cy.wrap(input).type('123');
        });

        cy.get('#submit').click();

        cy.wrap(onSubmit).should('have.been.calledWith', {
            name: '123',
            description: '123',
            location: '123',
            price: 123,
            currency: 'USD',
        });
    });
});
