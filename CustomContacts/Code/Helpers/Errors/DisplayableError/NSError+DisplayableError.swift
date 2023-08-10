//
//  NSError+DisplayableError.swift
//  CustomContacts
//
//  Created by Robert Deans on 08/10/2024.
//  Copyright © 2023 RBD. All rights reserved.
//

import Foundation
import LocalAuthentication

private let kCFErrorDomainCFNetworkSwiftString = kCFErrorDomainCFNetwork as String // Can't be put in switch case otherwise

extension NSError: DisplayableError {
	private var info: (title: String?, message: String?, buttonTitle: String?) {
		switch domain {
		case NSURLErrorDomain:
			let title: String?
			switch code {
			case NSURLErrorNetworkConnectionLost,
					 NSURLErrorNotConnectedToInternet,
					 NSURLErrorCannotFindHost,
					 NSURLErrorCannotConnectToHost,
					 NSURLErrorInternationalRoamingOff,
					 NSURLErrorCallIsActive,
					 NSURLErrorDataNotAllowed:
				title = "Internet Unreachable"
			default:
				title = nil
			}
			var message: String?
			switch code {
			case NSURLErrorCancelled,
			     NSURLErrorUserCancelledAuthentication:
				return ("Cancelled", "The request was cancelled.", nil)
			case NSURLErrorBadURL,
			     NSURLErrorZeroByteResource,
			     NSURLErrorUnsupportedURL,
			     NSURLErrorDNSLookupFailed,
			     NSURLErrorHTTPTooManyRedirects,
			     NSURLErrorResourceUnavailable,
			     NSURLErrorRedirectToNonExistentLocation,
			     NSURLErrorBadServerResponse,
			     NSURLErrorAppTransportSecurityRequiresSecureConnection,
			     NSURLErrorCannotLoadFromNetwork,
			     NSURLErrorDownloadDecodingFailedMidStream,
			     NSURLErrorDownloadDecodingFailedToComplete,
			     NSURLErrorRequestBodyStreamExhausted:
				message = "The server failed to reply to the request. Please try again later."
			case NSURLErrorTimedOut:
				return ("Timed Out", "The request timed out. Please check your internet connection and try again in a few seconds.", localizedRecoveryOptions?.first)
			case NSURLErrorNetworkConnectionLost,
			     NSURLErrorNotConnectedToInternet,
			     NSURLErrorCannotFindHost,
			     NSURLErrorCannotConnectToHost:
				message = "It looks like you're offline. Please try again once you're connected."
			case NSURLErrorUserAuthenticationRequired:
				message = "Please login and try again."
			case NSURLErrorZeroByteResource,
			     NSURLErrorCannotDecodeRawData,
			     NSURLErrorCannotDecodeContentData,
			     NSURLErrorCannotParseResponse,
			     NSURLErrorDataLengthExceedsMaximum:
				message = "An invalid response was received from the server."
			case NSURLErrorFileDoesNotExist,
			     NSURLErrorFileIsDirectory,
			     NSURLErrorNoPermissionsToReadFile:
				message = "We failed to open the requested item. Please try again in a few seconds."
			case NSURLErrorAppTransportSecurityRequiresSecureConnection,
			     NSURLErrorSecureConnectionFailed,
			     NSURLErrorServerCertificateHasBadDate,
			     NSURLErrorServerCertificateUntrusted,
			     NSURLErrorServerCertificateHasUnknownRoot,
			     NSURLErrorServerCertificateNotYetValid,
			     NSURLErrorClientCertificateRejected,
			     NSURLErrorClientCertificateRequired:
				message = "There is an error with the security settings of the remote server. Please try again later."
			case NSURLErrorCannotCreateFile:
				message = "There was an error creating this item. Please try again in a few seconds."
			case NSURLErrorCannotOpenFile:
				message = "There was an error opening this item. Please try again in a few seconds."
			case NSURLErrorCannotCloseFile:
				message = "There was an error closing this item. Please try again in a few seconds."
			case NSURLErrorCannotWriteToFile:
				message = "There was an error writing to this item. Please try again in a few seconds."
			case NSURLErrorCannotRemoveFile:
				message = "There was an error removing this item. Please try again in a few seconds."
			case NSURLErrorCannotMoveFile:
				message = "There was an error moving this item. Please try again in a few seconds."
			case NSURLErrorInternationalRoamingOff:
				message = "Please enable international roaming and try again."
			case NSURLErrorCallIsActive:
				message = "Please end the call and try again."
			case NSURLErrorDataNotAllowed:
				message = "Please enable data and try again."
			case NSURLErrorBackgroundSessionRequiresSharedContainer,
			     NSURLErrorBackgroundSessionInUseByAnotherProcess,
			     NSURLErrorBackgroundSessionWasDisconnected:
				message = "There was an error downloading this item in the background. Please try again later."
			default:
				break
			}
			return (title, message ?? localizedFailureReason ?? localizedDescription, localizedRecoveryOptions?.first)
		case kCFErrorDomainCFNetworkSwiftString:
			guard let error = CFNetworkErrors(rawValue: Int32(truncating: code as NSNumber)) else {
				return (nil, localizedFailureReason ?? localizedDescription, localizedRecoveryOptions?.first)
			}
			let title: String?
			switch error {
			case .cfHostErrorHostNotFound,
					 .cfErrorHTTPConnectionLost,
					 .cfurlErrorCannotFindHost,
					 .cfurlErrorCannotConnectToHost,
					 .cfurlErrorNetworkConnectionLost,
					 .cfurlErrorNotConnectedToInternet,
					 .cfurlErrorTimedOut,
					 .cfNetServiceErrorTimeout,
					 .cfurlErrorCallIsActive,
					 .cfurlErrorInternationalRoamingOff,
					 .cfurlErrorDataNotAllowed:
				title = "Internet Unreachable"
			default:
				title = nil
			}
			let message: String
			switch error {
			case .cfsocksErrorUnknownClientVersion,
					 .cfsocksErrorUnsupportedServerVersion,
					 .cfsocks4ErrorRequestFailed,
					 .cfsocks4ErrorIdentdFailed,
					 .cfsocks4ErrorIdConflict,
					 .cfsocks4ErrorUnknownStatusCode,
					 .cfsocks5ErrorBadState,
					 .cfsocks5ErrorBadResponseAddr,
					 .cfurlErrorUnsupportedURL,
					 .cfErrorHTTPParseFailure,
					 .cfsocks5ErrorBadCredentials,
					 .cfsocks5ErrorUnsupportedNegotiationMethod,
					 .cfsocks5ErrorNoAcceptableMethod,
					 .cfftpErrorUnexpectedStatusCode,
					 .cfErrorHTTPAuthenticationTypeUnsupported,
					 .cfErrorHTTPBadCredentials,
					 .cfErrorHTTPRedirectionLoopDetected,
					 .cfurlErrorBadURL,
					 .cfErrorHTTPBadURL,
					 .cfErrorHTTPProxyConnectionFailure,
					 .cfErrorHTTPBadProxyCredentials,
					 .cfErrorPACFileError,
					 .cfErrorPACFileAuth,
					 .cfErrorHTTPSProxyConnectionFailure,
					 .cfStreamErrorHTTPSProxyFailureUnexpectedResponseToCONNECTMethod,
					 .cfurlErrorBackgroundSessionInUseByAnotherProcess,
					 .cfurlErrorBackgroundSessionWasDisconnected,
					 .cfurlErrorHTTPTooManyRedirects,
					 .cfurlErrorRedirectToNonExistentLocation,
					 .cfurlErrorResourceUnavailable,
					 .cfurlErrorDNSLookupFailed,
					 .cfurlErrorBadServerResponse,
					 .cfurlErrorCannotLoadFromNetwork,
					 .cfurlErrorCannotCreateFile,
					 .cfurlErrorCannotOpenFile,
					 .cfurlErrorCannotCloseFile,
					 .cfurlErrorCannotWriteToFile,
					 .cfurlErrorCannotRemoveFile,
					 .cfurlErrorCannotMoveFile,
					 .cfurlErrorDownloadDecodingFailedMidStream,
					 .cfurlErrorDownloadDecodingFailedToComplete,
					 .cfhttpCookieCannotParseCookieFile,
					 .cfurlErrorZeroByteResource,
					 .cfurlErrorCannotDecodeRawData,
					 .cfurlErrorCannotDecodeContentData,
					 .cfurlErrorCannotParseResponse,
					 .cfurlErrorUserCancelledAuthentication,
					 .cfurlErrorUserAuthenticationRequired,
					 .cfurlErrorRequestBodyStreamExhausted,
					 .cfurlErrorFileDoesNotExist,
					 .cfurlErrorFileIsDirectory,
					 .cfurlErrorNoPermissionsToReadFile,
					 .cfurlErrorDataLengthExceedsMaximum,
					 .cfurlErrorFileOutsideSafeArea,
					 .cfNetServiceErrorCollision,
					 .cfNetServiceErrorNotFound,
					 .cfNetServiceErrorInProgress,
					 .cfNetServiceErrorBadArgument,
					 .cfNetServiceErrorInvalid,
					 .cfNetServiceErrorDNSServiceFailure:
				message = "The server failed to reply to the request. Please try again later."
			case .cfHostErrorHostNotFound,
					 .cfErrorHTTPConnectionLost,
					 .cfurlErrorCannotFindHost,
					 .cfurlErrorCannotConnectToHost,
					 .cfurlErrorNetworkConnectionLost,
					 .cfurlErrorNotConnectedToInternet:
				message = "It looks like you're offline. Please try again once you're connected."
			case .cfurlErrorCancelled,
					 .cfNetServiceErrorCancel:
				return ("Cancelled", "The request was cancelled.", nil)
			case .cfurlErrorTimedOut,
					 .cfNetServiceErrorTimeout:
				return ("Timed Out", "The request timed out. Please check your internet connection and try again in a few seconds.", localizedRecoveryOptions?.first)
			case .cfurlErrorCallIsActive:
				message = "Please end the call and try again."
			case .cfurlErrorInternationalRoamingOff:
				message = "Please enable international roaming and try again."
			case .cfurlErrorDataNotAllowed:
				message = "Please enable data and try again."
			case .cfurlErrorAppTransportSecurityRequiresSecureConnection,
					 .cfurlErrorSecureConnectionFailed,
					 .cfurlErrorServerCertificateHasBadDate,
					 .cfurlErrorServerCertificateUntrusted,
					 .cfurlErrorServerCertificateHasUnknownRoot,
					 .cfurlErrorServerCertificateNotYetValid,
					 .cfurlErrorClientCertificateRejected,
					 .cfurlErrorClientCertificateRequired:
				message = "There is an error with the security settings of the remote server. Please try again later."
			case .cfurlErrorUnknown,
					 .cfHostErrorUnknown,
					 .cfNetServiceErrorUnknown:
			fallthrough // swiftlint:disable:this fallthrough
			@unknown default:
				message = "An unknown error happened while processing the request. Please try again later."
			}
			return (title, message, localizedRecoveryOptions?.first)
		default:
			return (nil, localizedFailureReason ?? localizedDescription, localizedRecoveryOptions?.first)
		}
	}

	var title: String? {
		info.title
	}

	var message: String? {
		info.message
	}

	var buttonTitle: String? {
		info.buttonTitle
	}
}
