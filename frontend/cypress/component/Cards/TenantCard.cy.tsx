import TenantCard from '../../../src/components/Tenant/TenantCard';

describe('PropertyCard', () => {
    it('should render and react to events properly', () => {
        const onDeleteClick = cy.stub();
        const onEditClick = cy.stub();

        cy.mount(
            <TenantCard
                onDeleteClick={onDeleteClick}
                onEditClick={onEditClick}
                tenant={{
                    id: 1,
                    name: 'Test Tenant',
                }}
            />,
        );

        cy.get('.chakra-text').should('have.text', 'Test Tenant');
        cy.get('.chakra-text').click();
        cy.get('.icon-tabler-pencil').click();
        cy.get('.icon-tabler-trash').click();

        cy.wrap(onDeleteClick).should('have.been.called');
        cy.wrap(onEditClick).should('have.been.called');
    });
});
