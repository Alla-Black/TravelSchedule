import Foundation

protocol CarrierInfoRepository {
    func fetchCarrierInfo(code: String) async throws -> CarrierInfo
}
