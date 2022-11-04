import { List, ListItemButton, Button } from '@mui/material';

const CraftingComponent: React.FC = () => {
  return (
    <div className="crafting-container">
      <div className="crafting-nav">
        <List>
          <ListItemButton>General</ListItemButton>
          <ListItemButton>Drugs</ListItemButton>
          <ListItemButton>Tools</ListItemButton>
          <ListItemButton>Components</ListItemButton>
          <ListItemButton>Weapons</ListItemButton>
        </List>
      </div>
      <div className="crafting-items-container">
        <div className="crafting-items">
          <div className="crafting-item">Water</div>
          <div className="crafting-item">Soda</div>
          <div className="crafting-item">Water</div>
          <div className="crafting-item">Soda</div>
          <div className="crafting-item">Water</div>
          <div className="crafting-item">Soda</div>
          <div className="crafting-item">Water</div>
          <div className="crafting-item">Soda</div>
          <div className="crafting-item">Water</div>
          <div className="crafting-item">Soda</div>
          <div className="crafting-item">Water</div>
          <div className="crafting-item">Soda</div>
          <div className="crafting-item">Water</div>
          <div className="crafting-item">Soda</div>
          <div className="crafting-item">Water</div>
          <div className="crafting-item">Soda</div>
          <div className="crafting-item">Water</div>
          <div className="crafting-item">Soda</div>
          <div className="crafting-item">Water</div>
          <div className="crafting-item">Soda</div>
          <div className="crafting-item">Water</div>
          <div className="crafting-item">Soda</div>
          <div className="crafting-item">Water</div>
          <div className="crafting-item">Soda</div>
          <div className="crafting-item">Soda</div>
          <div className="crafting-item">Soda</div>
        </div>
      </div>
      <div className="crafting-requirements-container">
        <div className="crafting-requirements-wrapper">
          <div className="crafting-item">Water</div>
          <div className="crafting-requirements-list">
            <div className="crafting-requirements-header">Requirements</div>
            <div>
              <p>2x Wood</p>
              <p>5x Pogchamps</p>
              <p>Saw</p>
            </div>
          </div>
        </div>
        <div className="crafting-requirements-craft">
          <Button fullWidth variant="contained" classes="crafting-requirements-craft-button">
            Craft
          </Button>
        </div>
      </div>
    </div>
  );
};

export default CraftingComponent;
