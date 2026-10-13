using AutoMapper;using HealthPlatform.Domain.Patient;using HealthPlatform.Contracts;
namespace HealthPlatform.Application;
public sealed class PatientMapping:Profile{public PatientMapping(){CreateMap<PatientProfile,PatientDto>().MaxDepth(2);}}
