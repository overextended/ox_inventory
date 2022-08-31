import { Box, Stack, Typography, Button, TextField, Input, InputBase } from '@mui/material';
import ItemSlot from './components/ItemSlot';
import WeightBar from './components/utils/WeightBar';

const App: React.FC = () => {
  return (
    <Box sx={{ height: '100%', width: '100%', color: 'white' }}>
      <Stack direction="row" justifyContent="center" alignItems="center" height="100%" spacing={2}>
        <Box
          sx={
            {
              // height: 600,
            }
          }
        >
          <Stack spacing={1}>
            <Box>
              <Stack direction="row" justifyContent="space-between">
                <Typography fontSize={16}>Svetozar Miletic</Typography>
                <Typography fontSize={16}>13/30kg</Typography>
              </Stack>
              <WeightBar percent={(13 / 30) * 100} />
            </Box>
            <Box>
              <Box className={'inventory-grid'}>
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
              </Box>
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
        <Box
          sx={
            {
              // height: 600,
            }
          }
        >
          <Stack spacing={1}>
            <Box>
              <Stack direction="row" justifyContent="space-between">
                <Typography fontSize={16}>Svetozar Miletic</Typography>
                <Typography fontSize={16}>13/30kg</Typography>
              </Stack>
              <WeightBar percent={(13 / 30) * 100} />
            </Box>
            <Box>
              <Box className={'inventory-grid'}>
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
              </Box>
            </Box>
          </Stack>
        </Box>
      </Stack>
    </Box>
  );
};

export default App;
