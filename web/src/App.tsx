import { Box, Stack, Typography, Button, InputBase, styled } from '@mui/material';
import ItemSlot from './components/ItemSlot';
import WeightBar from './components/utils/WeightBar';

const StyledGrid = styled(Box)(() => ({
  display: 'grid',
  height: 'calc((5 * 10.42vh) + (5 * 2px))',
  gridTemplateColumns: 'repeat(5, 10.2vh)',
  gridAutoRows: '10.42vh',
  gap: '2px',
  overflowY: 'scroll',
}));

const App: React.FC = () => {
  return (
    <Box sx={{ height: '100%', width: '100%', color: 'white' }}>
      <Stack direction="row" justifyContent="center" alignItems="center" height="100%" spacing={2}>
        <Box>
          <Stack spacing={1}>
            <Box>
              <Stack direction="row" justifyContent="space-between">
                <Typography fontSize={16}>Svetozar Miletic</Typography>
                <Typography fontSize={16}>13/30kg</Typography>
              </Stack>
              <WeightBar percent={(13 / 30) * 100} />
            </Box>
            <Box>
              <StyledGrid>
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
              </StyledGrid>
            </Box>
          </Stack>
        </Box>
        <Box display="flex">
          <Stack spacing={3} justifyContent="center" alignItems="center">
            <InputBase />
            <Button fullWidth variant="contained">
              Use
            </Button>
            <Button fullWidth variant="contained">
              Give
            </Button>
            <Button fullWidth variant="contained">
              Close
            </Button>
          </Stack>
        </Box>
        <Box>
          <Stack spacing={1}>
            <Box>
              <Stack direction="row" justifyContent="space-between">
                <Typography fontSize={16}>Svetozar Miletic</Typography>
                <Typography fontSize={16}>13/30kg</Typography>
              </Stack>
              <WeightBar percent={(13 / 30) * 100} />
            </Box>
            <Box>
              <StyledGrid>
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
                <ItemSlot />
              </StyledGrid>
            </Box>
          </Stack>
        </Box>
      </Stack>
    </Box>
  );
};

export default App;
