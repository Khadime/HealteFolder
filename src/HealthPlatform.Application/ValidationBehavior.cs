using MediatR;using FluentValidation;
namespace HealthPlatform.Application;
public sealed class ValidationBehavior<TRequest,TResponse>(IEnumerable<IValidator<TRequest>> validators):IPipelineBehavior<TRequest,TResponse> where TRequest:notnull {
 public async Task<TResponse> Handle(TRequest request,RequestHandlerDelegate<TResponse> next,CancellationToken ct){var context=new ValidationContext<TRequest>(request);var results=await Task.WhenAll(validators.Select(v=>v.ValidateAsync(context,ct)));var errors=results.SelectMany(x=>x.Errors).ToArray();if(errors.Length>0)throw new ValidationException(errors);return await next();}
}
