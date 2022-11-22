import Label from '../../../src/components/Navigation/Label';

describe('Label.cy.tsx', () => {
    it('should render properly', () => {
        cy.mount(<Label icon={<p data-cy="icon">Icon</p>} label="Cypress" />);
        cy.get('[data-cy="icon"]').should('contain', 'Icon');
        cy.get('[data-cy="icon"]')
            .siblings()
            .first()
            .should('contain', 'Cypress');
    });
});
