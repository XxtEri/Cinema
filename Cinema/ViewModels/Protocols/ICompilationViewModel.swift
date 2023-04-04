//
//  ICompilationViewModel.swift
//  Cinema
//
//  Created by Елена on 04.04.2023.
//

import Foundation

protocol ICompulationViewModel {
    var compilationMovie: Observable<[Movie]> { get }
    var errorOnLoading: Observable<Error> { get }
    
    func getCompilation()
}
