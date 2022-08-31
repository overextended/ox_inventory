import { Box, styled, Stack, Typography } from '@mui/material';
import WeightBar from './utils/WeightBar';

const StyledBox = styled(Box)(() => ({
  backgroundColor: 'rgba(0, 0, 0, 0.4)',
  backgroundRepeat: 'no-repeat',
  backgroundPosition: 'center',
  borderRadius: '0.25vh',
  imageRendering: '-webkit-optimize-contrast',
  position: 'relative',
  backgroundSize: '7.7vh',
  color: '#C1C2C5',
}));

const StyledLabel = styled(Box)(() => ({
  backgroundColor: '#25262B',
  color: '#C1C2C5',
  width: '100%',
  textAlign: 'center',
  borderBottomLeftRadius: '0.25vh',
  borderBottomRightRadius: '0.25vh',
}));

const StyledDurability = styled(Box)(() => ({
  height: '5px',
  width: '100%',
  backgroundColor: 'rgba(0, 0, 0, 0.5)',
}));

const ItemSlot: React.FC = () => {
  return (
    <StyledBox sx={{ backgroundImage: `url(${`images/${'weapon_pistol'}.png`})` }}>
      <Stack justifyContent="space-between" height="100%">
        <Stack direction="row" alignSelf="flex-end" p="5px" spacing="1.5px">
          <Typography fontSize={12}>220g</Typography>
          <Typography fontSize={12}>10x</Typography>
        </Stack>
        <Box>
          <WeightBar percent={70} durability />
          <StyledLabel>
            <Typography fontSize={14}>PISTOL</Typography>
          </StyledLabel>
        </Box>
      </Stack>
    </StyledBox>
  );
};

export default ItemSlot;
