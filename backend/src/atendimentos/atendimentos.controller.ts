import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  Req,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';
import { AtendimentosService } from './atendimentos.service';
import {
  CreateAtendimentoDto,
  UpdateAtendimentoDto,
  AtendimentoResponseDto,
} from './dto/atendimentos.dto';

interface AuthenticatedRequest {
  user: { id: string };
}

@ApiTags('atendimentos')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'))
@Controller('atendimentos')
export class AtendimentosController {
  constructor(private readonly atendimentosService: AtendimentosService) {}

  @Post()
  @ApiOperation({ summary: 'Registrar novo atendimento' })
  @ApiResponse({
    status: 201,
    description: 'Atendimento registrado.',
    type: AtendimentoResponseDto,
  })
  create(
    @Body() dto: CreateAtendimentoDto,
    @Req() req: AuthenticatedRequest,
  ): Promise<AtendimentoResponseDto> {
    return this.atendimentosService.create(dto, req.user.id);
  }

  @Get()
  @ApiOperation({ summary: 'Listar todos os atendimentos' })
  @ApiResponse({
    status: 200,
    description: 'Lista de atendimentos.',
    type: [AtendimentoResponseDto],
  })
  findAll(
    @Query('page') page?: number,
    @Query('limit') limit?: number,
  ): Promise<AtendimentoResponseDto[]> {
    return this.atendimentosService.findAll(page || 1, limit || 20);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Buscar atendimento por ID' })
  @ApiResponse({
    status: 200,
    description: 'Atendimento encontrado.',
    type: AtendimentoResponseDto,
  })
  findOne(@Param('id') id: string): Promise<AtendimentoResponseDto> {
    return this.atendimentosService.findOne(id);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Atualizar atendimento' })
  @ApiResponse({
    status: 200,
    description: 'Atendimento atualizado.',
    type: AtendimentoResponseDto,
  })
  update(
    @Param('id') id: string,
    @Body() dto: UpdateAtendimentoDto,
  ): Promise<AtendimentoResponseDto> {
    return this.atendimentosService.update(id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Remover atendimento' })
  @ApiResponse({ status: 204, description: 'Atendimento removido.' })
  remove(@Param('id') id: string): Promise<void> {
    return this.atendimentosService.remove(id);
  }
}