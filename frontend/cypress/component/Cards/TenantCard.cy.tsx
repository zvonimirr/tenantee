import TenantCard from '../../../src/components/Tenant/TenantCard';

describe('TenantCard', () => {
    it('should render and react to events properly', () => {
        const onDeleteClick = cy.stub();
        const onEditClick = cy.stub();

        cy.mount(
            <TenantCard
                onClick={() => null}
                onDeleteClick={onDeleteClick}
                onEditClick={onEditClick}
                tenant={{
                    id: 1,
                    name: 'Test Tenant',
                    unpaid_rents: [],
                    properties: [],
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

    it('should render due rent', () => {
        // Get current date
        const date = new Date();
        // Set date 5 days in the future
        date.setDate(date.getDate() + 5);
        // Calculate due_date to YYYY-MM-DD format
        const due_date = date.toISOString().split('T')[0];

        cy.mount(
            <TenantCard
                onClick={() => null}
                onDeleteClick={() => null}
                onEditClick={() => null}
                tenant={{
                    id: 1,
                    name: 'Test Tenant',
                    unpaid_rents: [
                        {
                            id: 1,
                            paid: false,
                            due_date,
                        },
                    ],
                    properties: [],
                }}
            />,
        );

        cy.get('.chakra-text').last().should('have.text', 'Has due rent');
    });

    it('should render overdue rent', () => {
        const due_Date = new Date();
        due_Date.setDate(due_Date.getDate() - 5);
        // Calculate due_date to YYYY-MM-DD format
        const due_date = due_Date.toISOString().split('T')[0];

        cy.mount(
            <TenantCard
                onClick={() => null}
                onDeleteClick={() => null}
                onEditClick={() => null}
                tenant={{
                    id: 1,
                    name: 'Test Tenant',
                    unpaid_rents: [
                        {
                            id: 1,
                            paid: false,
                            due_date,
                        },
                    ],
                    properties: [],
                }}
            />,
        );

        cy.get('.chakra-text').last().should('have.text', 'Has overdue rent');
    });
});
